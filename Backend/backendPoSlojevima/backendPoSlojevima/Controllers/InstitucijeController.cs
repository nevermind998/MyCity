using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using backendPoSlojevima.Models;
using backendPoSlojevima.UI.Interfaces;
using Microsoft.Extensions.Configuration;
using Microsoft.AspNetCore.Authorization;
using MailKit.Net.Smtp;
using MimeKit;
using System.IO;

namespace backendPoSlojevima.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class InstitucijeController : Controller
    {
        private readonly IInstitucijeUI _IInstitucijeUI;
        private readonly IConfiguration _configuration;
        private readonly AuthRepository _auth;
        private readonly IGradKorisniciUI _IGradKorisniciUI;
        private readonly IReportUI _IReportUI;
        private readonly IObjaveUI _IObjaveUI;
        private readonly IInstitucijeKategorijeUI _IInstitucijeKategorijeUI;
        private readonly IObjaveKategorijeUI _IObjaveKategorijeUI;


        public InstitucijeController(IObjaveKategorijeUI IObjaveKategorijeUI, IInstitucijeKategorijeUI IInstitucijeKategorijeUI, IReportUI IReportUI, IInstitucijeUI IInstitucijeUI, IConfiguration configuration, IGradKorisniciUI IGradKorisniciUI, IObjaveUI IObjaveUI)
        {
            _IObjaveKategorijeUI = IObjaveKategorijeUI;
            _IInstitucijeKategorijeUI = IInstitucijeKategorijeUI;
            _IInstitucijeUI = IInstitucijeUI;
            _configuration = configuration;
            _auth = new AuthRepository(configuration);
            _IGradKorisniciUI = IGradKorisniciUI;
            _IObjaveUI = IObjaveUI;
            _IReportUI = IReportUI;
        }

        // GET: api/Institiucije
        [HttpPost]
        public async Task<ActionResult<IEnumerable< Korisnik>>> GetInstitucije()
        {
            return _IInstitucijeUI.getAllInstitucije();
        }
        
        [Route("Registracija")]
        [HttpPost]
        public IActionResult proveriPrijavu([FromBody]PrihvatanjeKorisnika data)
        {

            if (data == null)
            {
                return BadRequest();
            }
            var korisnik = data.korisnik;
            long ind = _IInstitucijeUI.proveraInstitucije(korisnik);

            if (ind == -1) return NoContent(); //204 //we have that usernameusername
            if (ind == -2) return Forbid(); //403

            //slanje mejla
            var random = new Random();
            var kod = random.Next(1000);
            kod = kod + random.Next(20, 200);
            kod = kod + random.Next(100, 200);
       
            var message = new MimeMessage();
            message.From.Add(new MailboxAddress("Moj grad", "mojgrad2020@gmail.com"));
            message.To.Add(new MailboxAddress("Moj grad", korisnik.email));
            message.Subject = "Moj grad";
            message.Body = new TextPart("plain")
            {
                Text = "Vaš kod je: " + kod
            };
            using (var client = new SmtpClient())
            {

                client.Connect("smtp.gmail.com", 587, false);
                client.Authenticate("mojgrad2020@gmail.com", "kragujevac034");
                client.Send(message);
                client.Disconnect(true);
                //client.Dispose();
            }

            return Ok(kod);

            /* PrihvatanjeKategorije kategorije = new PrihvatanjeKategorije();
             kategorije.idKategorije = data.idKategorija;
             kategorije.institucija = data.korisnik;
             _IInstitucijeKategorijeUI.dodajInstitucijiKategoriju(kategorije);
             _IGradKorisniciUI.dodajKorisnikaZaGradove(data);*/
            //saved user
        }
        [Route("sacuvajKorisnika")]
        [HttpPost]
        public async Task<IActionResult> sacuvajKorisnika ([FromBody]PrihvatanjeKorisnika data)
        {
           if (data == null)
            {
                return BadRequest();
            }
            var korisnik = data.korisnik;
            long ind = _IInstitucijeUI.saveInstituciju(korisnik);

            if (ind == -1) return NoContent(); //204 //we have that username

            PrihvatanjeKategorije kategorije = new PrihvatanjeKategorije();
            kategorije.idKategorije = data.idKategorija;
            kategorije.institucija = data.korisnik;
            _IInstitucijeKategorijeUI.dodajInstitucijiKategoriju(kategorije);
            _IGradKorisniciUI.dodajKorisnikaZaGradove(data);
            return Ok();
        }

        [Route("login")]
        [HttpPost]
        public IActionResult LoginCheck([FromBody]Korisnik data)
        {

            if (data == null)
            {
                return BadRequest();
            }
            var institucija = _IInstitucijeUI.LoginCheck(data);
            if ( institucija == null)
            {
                var response = "Pogrešno korisničko ime/šifra";
                return BadRequest(response);
            }
            institucija.gradovi = _IGradKorisniciUI.getAllGradoveByIdKorisnika(institucija.id);
            return Ok(institucija);
            //  return Ok(data);
        }
        
        [Authorize]
        [Route("azuriranjeProfila")]
        [HttpPost]
        public IActionResult azurirajPodatkeKorisnika([FromBody]AzuriranjeInstitucije data)
        {
            if (data == null)
            {
                return BadRequest();
            }
            string token = Request.Headers["Authorization"];
            token = token.Split(" ")[1];
            int ind = _IInstitucijeUI.izmeniPodatke(data, token);
            if (ind == -1) return NoContent();//los username 204
            if (ind == -2) return NotFound(); //losa sifra 404
            if (ind == -3) return Problem(); //nije dobar token
            _IGradKorisniciUI.izmeniGradoveZaKorisnika(data.korisnik.id, data.idGradova);
            _IInstitucijeKategorijeUI.izmeniKategorijeZaKorisnika(data.korisnik.id, data.kategorije);
            return Ok();
        }

        [Authorize]
        [Route("pretraga")]
        [HttpPost]
        public ActionResult<List<Institucije>> pretragaImena([FromBody]Pretraga data)
        {

            if (data == null)
            {
                return BadRequest();
            }

            var institucije = _IInstitucijeUI.getInstitucijeByFilter(data.filter);

            return Ok(institucije);
        }
        //treba token da se salje
    	[Authorize]
        [Route("dodajProfilnuSliku")]
        [HttpPost]
        public ActionResult addProfilnuSliku([FromBody]PrihvatanjeSlike image)
        {

            if (image == null)
            {
                return BadRequest();
            }
            string token = Request.Headers["Authorization"];
            token = token.Split(" ")[1];
            _IInstitucijeUI.dodajProfilnuSlikuInstituciji(image,token);

            return Ok();
        }
        /*[Route("posaljiInstitucijuProfilneSlike")]
 	[Authorize]
        [HttpPost]
        public ActionResult<List<Korisnik>>  posaljiInstitucijuProfilneSlike([FromBody]PrihvatanjeIdInstitucije idInstitucije)
        {

            if (idInstitucije == null)
            {
                return BadRequest();
            }

           var  institucija = _IInstitucijeUI.dodajProfilnuSlikuInstitiuciji(idInstitucije);

            return Ok(institucija);
        }
        */
        [Authorize]
        [Route("odjava")]
        [HttpPost]
        public IActionResult odjava([FromBody] PrihvatanjeIdInstitucije data)
        {

            if (data == null)
            {
                return BadRequest();
            }
            var  institucija = _IInstitucijeUI.unistiToken(data);
            return Ok(institucija);
        }

        /*[Route("problemJeResen")]
        [HttpPost]
        public IActionResult resenProblem([FromBody]PrihvatanjeIdObjave data)
        {
            if (data == null)
            {
                return BadRequest();
            }
            int ind = 1; //institucija = 1
            return Ok(_IObjaveUI.problemResen(data,ind));

        }*/
        [Route("reseneObjaveZaInstituciju")]
        [HttpPost]
        public IActionResult dajReseneProbleme([FromBody]PrihvatanjeIdInstitucije data)
        {
            if (data == null)
            {
                return BadRequest();
            }

            return Ok(_IObjaveUI.dajReseneProblemeZaInstituiju(data));
        }
	    [Authorize]
        [Route("prikaziNereseneProbleme")]
        [HttpPost]
        public IActionResult nereseniproblemi([FromBody]PrihvatanjeIdInstitucije data)
        {
            if (data == null)
            {
                return BadRequest();
            }

            return Ok(_IObjaveUI.dajNeReseneProblemeZaInstituiju(data.idInstitucije));
        }
	    [Authorize]
        [Route("prikaziReseneProbleme")]
        [HttpPost]
        public IActionResult Reseniproblemi([FromBody]PrihvatanjeIdInstitucije data)
        {
            if (data == null)
            {
                return BadRequest();
            }

            return Ok(_IObjaveUI.prikaziSveReseneObjave(data.idInstitucije));
        }
        [Authorize]
        [Route("prikazPocetneStrane")]
        [HttpPost]
        public IActionResult prikazPocetneStrane([FromBody]PrihvatanjeIdInstitucije data)
        {
            if (data == null)
            {
                return BadRequest();
            }
            return Ok(_IObjaveUI.prikaziPocetnuStranu(data.idInstitucije));
        }
      
        [Authorize]
        [Route("prikaziReseneProblemPocetneStrane")]
        [HttpPost]
        public IActionResult prikaziReseneProblemPocetnuStranu([FromBody]PrihvatanjeIdInstitucije data)
        {
            if (data == null)
            {
                return BadRequest();
            }

            return Ok(_IObjaveUI.prikaziReseneProblemPocetnuStranu(data.idInstitucije));
        }
        [Authorize]
        [Route("dajKategorijeZaInstituciju")]
        [HttpPost]
        public IActionResult dajKategorijeZaInstituciju([FromBody]PrihvatanjeIdInstitucije data)
        {
            if (data == null)
            {
                return BadRequest();
            }

            return Ok(_IInstitucijeKategorijeUI.getKategorijeByIdInstitucije(data.idInstitucije));
        }



    }
}
