using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using backendPoSlojevima.Data;
using backendPoSlojevima.Models;
using backendPoSlojevima.UI.Interfaces;
using Microsoft.Extensions.Configuration;
using Microsoft.AspNetCore.Authorization;

namespace backendPoSlojevima.Controllers
{
    [Route("api/[controller]")]
    [ApiController]

    public class AdministratorController : ControllerBase
    {
        private readonly IAdministratorUI _IAdministratorUI;
        private readonly IObjaveUI _IObjaveUI;
        private readonly IKomentariUI _IKomentariUI;
        private readonly IReportUI _IReportUI;
        private readonly IReportKomentaraUI _IReportKomentaraUI;
        private readonly IDislajkoviKomentaraUI _IDislajkoviKomentaraUI;
        private readonly IKorisnikUI _IKorisnikUI;
        private readonly IGradKorisniciUI _IGradKorisniciUI;
        private readonly IObjaveKategorijeUI _IObjaveKategorijeUI;



        public AdministratorController(IObjaveKategorijeUI IObjaveKategorijeUI, IGradKorisniciUI IGradKorisniciUI, IKorisnikUI IKorisnikUI, IDislajkoviKomentaraUI IDislajkoviKomentaraUI, IReportKomentaraUI IReportKomentaraUI, IKomentariUI iKomentariUI, IReportUI iReportUI, IAdministratorUI iAdministratorUI, IObjaveUI IObjaveUI)
        {
            _IKorisnikUI = IKorisnikUI;
            _IAdministratorUI = iAdministratorUI;
            _IObjaveUI = IObjaveUI;
            _IReportUI = iReportUI;
            _IKomentariUI = iKomentariUI;
            _IReportKomentaraUI = IReportKomentaraUI;
            _IDislajkoviKomentaraUI = IDislajkoviKomentaraUI;
            _IGradKorisniciUI = IGradKorisniciUI;
            _IObjaveKategorijeUI = IObjaveKategorijeUI;
        }

        // GET: api/Administrator
  //      [Authorize(Roles = "admin,superuser")]
        [HttpPost]
        public async Task<ActionResult<IEnumerable<Korisnik>>> GetAdministrator()
        {
            return _IAdministratorUI.getAllAdministrator();
        }
        
        [Route("loginWeb")]
        [HttpPost]
        public ActionResult proveraAdmina([FromBody]Korisnik data)
        {
            if(data == null)
            {
                return BadRequest();
            }
            string response;
            var user = _IAdministratorUI.LoginCheck(data);
            if (user == null)
            {
                response = "Pogrešno korisničko ime/šifra";
                return BadRequest(response);
            }
            
            return Ok(user);
        }

        [Authorize(Roles = "admin,superuser")]
        [Route("Objave")]
        [HttpGet]
        public IActionResult getObjave()//objave sa 2+ reporta
        {
            PrihvatanjeIdKorisnika pid = new PrihvatanjeIdKorisnika();
            pid.idKorisnika = 1;
            List<SveObjave> sveObjave = _IObjaveUI.vratiSveObjave(pid);
            List<SveObjave> objave = new List<SveObjave>();
            // to = _IObjaveUI.getAllObjave();

            foreach (var item in sveObjave)
            {
                PrihvatanjeIdObjave data = new PrihvatanjeIdObjave();
                data.idObjave = item.idObjave;
                if (_IReportUI.dajSveReportoveByIdObjave(data) >= 2)
                {
                    //SveZaObjavu svz = new SveZaObjavu();
                    //svz = _iObjaveUI.dajSveZaObjavu(data);
                    objave.Add(item);
                }
            }

            return Ok(objave);
        }


        [Authorize(Roles = "admin,superuser")]
        [Route("brisanjeObjave")]
        [HttpPost]
        public IActionResult brisanjeObjave([FromBody]PrihvatanjeIdObjave data)
        {
            if (data == null)
            {
                return BadRequest();
            }
            int ind = 1;
            _IObjaveUI.deleteSveZaObjavuByIdObjave(data,ind);

            return Ok();
        }

        [Authorize(Roles = "superuser")]
        [Route("vratiUloguKorisnika")]
        [HttpPost]
        public IActionResult vratiUloguKorisnika([FromBody]PrihvatanjeIdKorisnika data)
        {
            if (data == null)
            {
                return BadRequest();
            }
            int ind = 1;
            _IKorisnikUI.vratiUloguKorisnika(data.idKorisnika);

            return Ok();
        }


        [Authorize(Roles = "superuser")]
        [Route("brisanjeAdmina")] //brisanje admina
        [HttpPost]
        public IActionResult brisanjeKorisnika([FromBody]PrihvatanjeIdKorisnika data)
        {
            if (data == null)
            {
                return BadRequest();
            }
            string token = Request.Headers["Authorization"];
            token = token.Split(" ")[1];
          // _IObjaveUI.deleteSveZaObjavuByIdKorisnika(data);
            var obrisan = _IKorisnikUI.deleteKorisnikaByAdmin(data.idKorisnika,token);

            return Ok(obrisan);
        }
        [Authorize(Roles = "admin,superuser")]
        [Route("brisanjeKorisnika")] //brisanje admina
        [HttpPost]
        public IActionResult brisanjeKorisnikaZaSveAdmine([FromBody]PrihvatanjeIdKorisnika data)
        {
            if (data == null)
            {
                return BadRequest();
            }
            string token = Request.Headers["Authorization"];
            token = token.Split(" ")[1];

            // _IObjaveUI.deleteSveZaObjavuByIdKorisnika(data);
            _IKorisnikUI.deleteKorisnikaById(data,token);

            return Ok();
        }
        /*
          [Route("prikaziKorisnike")]
          [HttpPost]
          public IActionResult prikazKorisnika()
          {
              List<Korisnik> korisnici = _IKorisnikUI.prikaziKorisnikaZaAdmina();

              return Ok(korisnici);
          }*/
        /*
         [Route("pretraga")]
         [HttpPost]
         public IActionResult pretragaKorisnika([FromBody] Pretraga data)
         {
             //List<Korisnik> korisnici = _IKorisnikUI.pretragaKorisnikZaAdmina(data.filter);

             return Ok(korisnici);
         }*/
        [Authorize(Roles = "admin,superuser")]
        [Route("brisanjeKomentara")]
        [HttpPost]
        public IActionResult brisanjeKomentara([FromBody]PrihvatanjeIdKomentara data)
        {

           
            if (data == null)
            {
                return BadRequest();
            }
            int ind = 1; //admin
            _IKomentariUI.deleteKomentarByIdKomentara(data,ind);

            return Ok();
        }

        [Authorize(Roles = "admin,superuser")]
        [Route("Komentari")]
        [HttpGet]
        public IActionResult getKomentari()
        {
            List<Komentari> komentari = _IKomentariUI.getAllKomentari();

            List<Komentari> vratiKomentare= new List<Komentari>();

            foreach (var komentar in komentari)
            {
                if(_IReportKomentaraUI.getBrojReportaByIdKomentara(komentar.id) > 2 || _IDislajkoviKomentaraUI.getBrojDislajkovaByIdKomentara(komentar.id) >=2)
                {
                    vratiKomentare.Add(komentar);
                }
            }

            return Ok(vratiKomentare);
        }
        [Authorize(Roles = "admin,superuser")]
        [Route("postavljanjeAdmina")]
        [HttpPost]
        public IActionResult Admin([FromBody]PrihvatanjeIdKorisnika idKorisnika)
        {

            if (idKorisnika == null)
            {
                return BadRequest();
            }
            Korisnik korisnik = _IKorisnikUI.postaviAdmina(idKorisnika);
            return Ok(korisnik);
        }

        /* [Route("prikazKorisnikePoGraduIBrojuPrijavljenihObjava")]
         [HttpPost]
         public IActionResult vratiKorisnikeByReportaObjava([FromBody]PrihvatanjeIdKorisnika korisnika)
         {

             if (korisnika == null)
             {
                 return BadRequest();
             }
             var korisnik = _IKorisnikUI.vratiKorisnikeByReportaObjava(korisnika);
             return Ok(korisnik);
         }


         [Route("prikazKorisnikePoGraduIBrojuPrijavljenihKomentara")]
         [HttpPost]
         public IActionResult vratiKorisnikeByReportaKomentara([FromBody]PrihvatanjeIdKorisnika korisnika)
         {

             if (korisnika == null)
             {
                 return BadRequest();
             }
             var korisnik = _IKorisnikUI.vratiKorisnikeByReportaKomentara(korisnika);
             return Ok(korisnik);
         }
         [Route("prikazKorisnikePoGraduIBrojuPrijavljenihKomentaraIObjava")]
         [HttpPost]
         public IActionResult vratiKorisnikeByReportaKomentaraIObjava([FromBody]PrihvatanjeIdKorisnika korisnika)
         {

             if (korisnika == null)
             {
                 return BadRequest();
             }
             var korisnik = _IKorisnikUI.vratiKorisnikeByReportaKomentara(korisnika);
             return Ok(korisnik);
         }*/
        [Authorize(Roles = "admin,superuser")]
        [Route("prikazKorisnika")]
        [HttpPost]
        public IActionResult prikaziKorisnika([FromBody]PretragaKorisnika korisnika)
        {

            if (korisnika == null)
            {
                return BadRequest();
            }
            var korisnici = _IKorisnikUI.pretragaKorisnikZaAdmina(korisnika);
            korisnici = _IObjaveUI.vratiAdminu(korisnici);
            return Ok(korisnici);
        }
        [Authorize(Roles = "admin,superuser")]
        [Route("prikazSvihKorisnika")]
        [HttpPost]
        public IActionResult prikaziSvihKorisnika()
        {
            return Ok(_IKorisnikUI.getAllKorisnik());
        }
       [Authorize(Roles = "admin,superuser")]
        [Route("prikaziStatistikuOduvek")] //kategorija, grad oduvek
        [HttpPost]
        public IActionResult prikaziStatistiku([FromBody]PrihvatanjeIdGrada grad)
        {
            if(grad == null)
            {
                return BadRequest();
            }
            return Ok(_IObjaveUI.prikaziStatistiku(grad.idGrada,grad.kategorija));
        }
       [Authorize(Roles = "admin,superuser")]
        [Route("prikaziStatistikuZa7Dana")]
        [HttpPost]
        public IActionResult prikaziStatistikuZa7Dana([FromBody]PrihvatanjeIdGrada grad)
        {
            if (grad == null)
            {
                return BadRequest();
            }
            
            return Ok(_IObjaveUI.prikaziStatistikuZa7Dana(grad.idGrada,grad.kategorija));
        }
        [Authorize(Roles = "admin,superuser")]
        [Route("prikaziStatistikuZa30Dana")]
        [HttpPost]
        public IActionResult prikaziStatistikuZa30Dana([FromBody]PrihvatanjeIdGrada grad)
        {
            if (grad == null)
            {
                return BadRequest();
            }

            return Ok(_IObjaveUI.prikaziStatistikuZa30Dana(grad.idGrada, grad.kategorija));
        }
        [Authorize(Roles = "admin,superuser")]
        [Route("tabelaObjava")]
        [HttpPost]
        public IActionResult tabelaObjava([FromBody] PrihvatanjeIdGrada data)
        {
            if (data == null)
            {
                return BadRequest();
            }
            return Ok(_IObjaveUI.tabelaObjava(data.idGrada,data.kategorija));
        }
        [Authorize(Roles = "admin,superuser")]
        [Route("tabelaObjavaZa30Dana")]
        [HttpPost]
        public IActionResult tabelaObjavaZa30Dana([FromBody] PrihvatanjeIdGrada data)
        {
            if (data == null)
            {
                return BadRequest();
            }
            return Ok(_IObjaveUI.tabelaObjavaZa30dana(data.idGrada, data.kategorija));
        }
        [Authorize(Roles = "admin,superuser")]
        [Route("tabelaObjavaZa7Dana")]
        [HttpPost]
        public IActionResult tabelaObjavaZa7Dana([FromBody] PrihvatanjeIdGrada data)
        {
            if (data == null)
            {
                return BadRequest();
            }
            return Ok(_IObjaveUI.tabelaObjavaZa7Dana(data.idGrada, data.kategorija));
        }
        [Authorize(Roles = "admin,superuser")]
        [Route("prikaziPrijavljeneObjave")]
        [HttpPost]
        public IActionResult prikaziObjave([FromBody]PrihvatanjeIdGrada grad)
        {
            if (grad == null)
            {
                return BadRequest();
            }
            return Ok(_IObjaveUI.prikaziObjaveZaAdministratora(grad.idGrada));
        }

        [Route("maxIminPrijavljenihObjavaPoKorinsiku")]
        [HttpPost]
        public IActionResult minImaxPrijavljenihObjava()
        {
            return Ok(_IReportUI.getMinIMaxBroj());
        }
        [Route("maxIminPrijavljenihKomentaraPoKorinsiku")]
        [HttpPost]
        public IActionResult minImaxPrijavljenihKomentara()
        {
            return Ok(_IReportKomentaraUI.getMinIMaxBroj());
        }
        [Authorize(Roles = "admin,superuser")]
        [Route("odjava")]
        [HttpPost]
        public IActionResult odjava([FromBody]PrihvatanjeIdKorisnika data)
        {
            return Ok(_IAdministratorUI.odjavaKorisnika(data.idKorisnika));
        }
        [Authorize(Roles = "admin,superuser")]
        [Route("ocenaAplikacije")]
        [HttpPost]
        public IActionResult ocenaAplikacije()
        {
            return Ok(_IKorisnikUI.ocenaAplikacije());
        }

        [Authorize(Roles = "admin,superuser")]
        [Route("statistikaZaKategoriju")]
        [HttpPost]
        public IActionResult statistikaZaKategoriju([FromBody]PrihvatanjeKategorije kategorija)
        {
            return Ok(_IObjaveUI.statistikaPoKategoriji(kategorija));
        }
        [Authorize(Roles = "admin,superuser")]
        [Route("top10GradovaPoPoenima")]
        [HttpPost]
        public IActionResult top10GradovaPoPoenima()
        {
            return Ok(_IGradKorisniciUI.top10Gradova());
        }
        [Authorize(Roles = "admin,superuser")]
        [Route("top10KorisnikaPoPoenima")]
        [HttpPost]
        public IActionResult top10KorisnikaPoPoenima()
        {
            return Ok(_IKorisnikUI.top10PoPoenima());
        }
        [Authorize(Roles = "admin,superuser")]
        [Route("statistikaPoKategoriji")]
        [HttpPost]
        public IActionResult statistikaPoKategoriji([FromBody]PrihvatanjeKategorije data)
        {
            if (data == null )
            {
                return BadRequest();
            }
            return Ok(_IObjaveUI.statistikaPoKategoriji(data));
        }

        [Authorize(Roles = "admin,superuser")]
        [Route("kategorijeSaNajviseObjava")]
        [HttpPost]
        public IActionResult kategorijeSaNajviseObjava()
        {
            return Ok(_IObjaveUI.kategorijeSaNajviseObjava());
        }
        [Authorize(Roles = "admin,superuser")]
        [Route("gradoviSaNajviseObjava")]
        [HttpPost]
        public IActionResult topGradoviPoObjavama()
        {
            return Ok(_IObjaveUI.topGradoviPoObjavama());
        }

        [Authorize(Roles = "admin,superuser")]
        [Route("brojKorisnikaPoGradovima")]
        [HttpPost]
        public IActionResult brojKorisnikaPoGradovima()
        {
            return Ok(_IGradKorisniciUI.brojKorisnikaPoGradovima());
        }
        [Authorize(Roles = "admin,superuser")]
        [Route("oduzmiPoeneKorisniku")]
        [HttpPost]
        public IActionResult oduzmiPoeneKorisniku([FromBody] PrihvatanjePoena data)
        {
            if (data == null)
            {
                return BadRequest();
            }
            _IKorisnikUI.oduzmiPoeneKorisniku(data);
            return Ok();
        }
        [Authorize(Roles = "admin,superuser")]
        [Route("dodajPoeneKorisniku")]
        [HttpPost]
        public IActionResult dodajPoeneKorisniku([FromBody] PrihvatanjePoena data)
        {
            if (data == null)
            {
                return BadRequest();
            }
            _IKorisnikUI.dodajPoeneKorisniku(data);
            return Ok();
        }


        [Authorize]
        [Route("dajObjave")]
        [HttpPost]
        public IActionResult dajObjave([FromBody]Pretraga data)
        {
            if (data == null)
            {
               return BadRequest();
            }
            var objave = _IObjaveUI.dajObjaveZaAdmina(data);
            return Ok(objave);
        }



    }
}
