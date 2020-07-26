using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using backendPoSlojevima.Models;
using backendPoSlojevima.UI.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using System.Linq;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using System.IdentityModel.Tokens.Jwt;
using System;
using System.Text;
using Microsoft.AspNetCore.Identity;
using MailKit.Net.Smtp;
using MimeKit;
using System.IO;


namespace backendPoSlojevima.Controllers
{
    //[Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class KorisnikController : Controller
    {
        private readonly IKorisnikUI _IKorisnikUI;
        private readonly IObjaveUI _IObjaveUI;
        private readonly IGradKorisniciUI _IGradKorisniciUI;
        private readonly IKomentariUI _IKomentariUI;
     

        public KorisnikController(IKorisnikUI IKorisnikUI, IObjaveUI IObjaveUI, IGradKorisniciUI IGradKorisniciUI, IKomentariUI IKomentariUI)
        {
            _IKorisnikUI = IKorisnikUI;
            _IObjaveUI = IObjaveUI;
            _IGradKorisniciUI = IGradKorisniciUI;
            _IKomentariUI = IKomentariUI;
        }

      /*  // GET: api/Korisnik
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Korisnik>>> GetKorisnike()
        {
            return _IKorisnikUI.getAllKorisnik();
        }*/
        [Route("KorisniciIGradovi")]
        [HttpPost]
        public IActionResult getAllKorisnikGrad()
        {
            return Ok(_IKorisnikUI.getAllKorisnikGrad());
        }

        [Route("dajKorisnika")]
        [HttpPost]
        public IActionResult AddKorisnik([FromBody]PrihvatanjeIdKorisnika data)
        {
            if (data == null)
            {
                return BadRequest();
            }
            var korisnik = _IKorisnikUI.posaljiKorisnika(data.idKorisnika);
            if (korisnik == null) return NoContent();
            return Ok(korisnik); 
        }
       

        [Route("Registracija")]
        [HttpPost]
        public async Task<IActionResult> AddKorisnik([FromBody]PrihvatanjeKorisnika  data)
        {
            if (data == null)
            {
                return BadRequest();
            }
            var korisnik = data.korisnik;
            long ind = _IKorisnikUI.proveraKorisnika(korisnik);
            if (ind == -1) return NoContent(); //204 //we have that username
            if (ind == -2) return Forbid(); //403 ima taj email vec
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

            // _IGradKorisniciUI.dodajKorisnikaZaGradove(data);
          
        }

        [Route("sacuvajKorisnika")]
        [HttpPost]
        public async Task<IActionResult> cuvajKorisnika([FromBody]PrihvatanjeKorisnika data)
        {
            if (data == null)
            {
                return BadRequest();
            }
            var korisnik = data.korisnik;
            var ind = _IKorisnikUI.saveKorisnik(korisnik);
            if (ind != null)
            {
                _IGradKorisniciUI.dodajKorisnikaZaGradove(data);
            }
           
            return Ok();
        }

        [Route("zaboravljenaSifra")]
        [HttpPost]
        public async Task<IActionResult> zaboravljenaSifra([FromBody]ZaboravljenaSifra data)
        {
            if (data == null)
            {
                return BadRequest();
            }
            
            _IKorisnikUI.zaboravljenaSifra(data);
            return Ok();
        }


        [Route("login")]
        [HttpPost]
        public IActionResult LoginCheck([FromBody] Korisnik data)
        {
            if (data == null)
            {
                return BadRequest();
            }

            string response;
            var user = _IKorisnikUI.LoginCheck(data);
            if (user == null)
            {
                response = "Pogrešno korisničko ime/šifra";
                return BadRequest(response);
            }
            
            user.gradovi = _IGradKorisniciUI.getAllGradoveByIdKorisnika(user.id);
            return Ok(user);
           
        }
        [Authorize]
        [Route("odjava")]
        [HttpPost]
        public IActionResult odjava([FromBody] PrihvatanjeIdKorisnika data)
        {
            if (data == null)
            {
                return BadRequest();
            }
            string token = Request.Headers["Authorization"];
            token = token.Split(" ")[1];
            Korisnik korisnik = _IKorisnikUI.odjavaKorisnika(data,token);
            return Ok(korisnik);
        }

        [Authorize]
        [Route("pretraga")]
        [HttpPost]
        //  public ActionResult<List<Korisnik>> pretragaImena([FromBody]Pretraga data)
        public IActionResult pretragaImena([FromBody]Pretraga data)
        {

            if (data == null)
            {
                return BadRequest();
            }

            List<KorisnikSaGradovima> korisnici = _IKorisnikUI.getKorisnikByFilter(data.filter);
            return Ok(korisnici);
        }
        [Authorize]
        [Route("dodajProfilnuSliku")]
        [HttpPost]
        public ActionResult addProfilnuSliku([FromForm]PrihvatanjeSlike image)
        {
            string token = Request.Headers["Authorization"];
            token = token.Split(" ")[1];
            if (image == null)
            {
                return BadRequest();
            }

            _IKorisnikUI.saveProfilImage(image,token);

            return Ok();
        }
        /*[Route("posaljiKorisnikaProfilneSlike")]
        [HttpPost]
        public ActionResult<List<Korisnik>> posaljiKorisnikaProfilnuSliku([FromBody]PrihvatanjeIdKorisnika idKorisnika)
        {

            if (idKorisnika  == null)
            {
                return BadRequest();
            }

            Korisnik korisnik = _IKorisnikUI.dodajProfilnuSlikuKorisniku(idKorisnika);
            
            return Ok(korisnik);
        }
        */
        [Authorize]
        [Route("azuriranjeProfila")]
        [HttpPost]
        public IActionResult azurirajPodatkeKorisnika([FromBody]AzuriranjeKorisnika data)
        {
            if (data == null)
            {
                return BadRequest();
            }
            string token = Request.Headers["Authorization"];
            token = token.Split(" ")[1];
            int ind = _IKorisnikUI.izmeniPodatke(data,token);
            if (ind == -1) return NoContent();//los username 204
            if (ind == -2) return NotFound(); //losa sifra 404
            if (ind == -3) return Problem(); //nije dobar token
            _IGradKorisniciUI.izmeniGradoveZaKorisnika(data.korisnik.id, data.idGradova);
            return Ok();
        }


        [Authorize]
        [Route("brisanjeKorisnika")]
        [HttpPost]
        public IActionResult brisanjeKorisnika([FromBody]PrihvatanjeIdKorisnika data)
        {
            if (data == null)
            {
                return BadRequest();
            }
            string token = Request.Headers["Authorization"];
            token = token.Split(" ")[1];

            //  _IObjaveUI.deleteSveZaObjavuByIdKorisnika(data);
           // _IObjaveUI.deleteSveZaObjavuByIdKorisnika(data);
            _IKorisnikUI.deleteKorisnikaById(data,token);
    

            return Ok();
        }
        [Authorize]
        [Route("dajBoje")]
        [HttpPost]
        public IActionResult dajBoje([FromBody]PrihvatanjeIdKorisnika data)
        {
            if (data == null)
            {
                return BadRequest();
            }
            return Ok(_IKorisnikUI.getBojeZaKorisnika(data));
        }

        [Authorize]
        [Route("dodajOcenu")]
        [HttpPost]
        public IActionResult dodajOcenu([FromBody]PrihvatanjeIdKorisnika data)
        {
            if (data == null)
            {
                return BadRequest();
            }
            _IKorisnikUI.dodajOcenu(data);
            return Ok();
        }
    }
}
