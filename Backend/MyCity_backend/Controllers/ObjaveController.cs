using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using backendPoSlojevima.Data;
using backendPoSlojevima.Models;
using backendPoSlojevima.UI.Interfaces;
using Microsoft.AspNetCore.Http;
using System.Net;
using Microsoft.VisualStudio.Imaging;
using System.IO;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Authorization;

namespace backendPoSlojevima.Controllers
{
    [Route("api/[controller]")]
    [ApiController] 
    public class ObjaveController : Controller
    {
        private readonly  ITekstualneObjaveUI _ITekstualneObjaveUI;
        private readonly IObjaveUI _IObjaveUI;
        private readonly ISlikeUI _ISlikeUI;
        private readonly ApplicationDbContext _context;
        private readonly IWebHostEnvironment _IWebHostEnvironment;
        private readonly IObjaveKategorijeUI _IObjaveKategorijeUI;
        private readonly IKategorijeProblemaUI _IKategorijaProblemaUI;


        public ObjaveController(IKategorijeProblemaUI IKategorijaProblemaUI, IObjaveKategorijeUI IObjaveKategorijeUI, ITekstualneObjaveUI ITekstualneObjaveUI, IObjaveUI IObjaveUI, ISlikeUI ISlikeUI, ApplicationDbContext context, IWebHostEnvironment webHostEnvironment)
        {
            _ITekstualneObjaveUI = ITekstualneObjaveUI;
            _IKategorijaProblemaUI = IKategorijaProblemaUI;
            _IObjaveUI = IObjaveUI;
            _ISlikeUI = ISlikeUI;
            _context = context;
            _IWebHostEnvironment = webHostEnvironment;
            _IObjaveKategorijeUI = IObjaveKategorijeUI;
        }
        // GET: api/Objave
         [HttpGet]
          public async Task<ActionResult<IEnumerable<Objave>>> GetObjave()
          {
            return _IObjaveUI.getAllObjave();
          }
          

	    [Authorize]
        [Route("dodajTekstualnuObjavu")]
        [HttpPost]
        public IActionResult AddTekstualneObjave([FromBody]PrihvatanjeObjave data)
        {
            if (data == null)
            {
                return BadRequest();
            }
          //  var _contex = new ApplicationDbContext();
          // var tip = _contex.tip_objave.FirstOrDefault(o => o.vrsta == "tekstualne_objave").id;
            data.tip = 2;
            _IObjaveUI.saveObjavu(data);
            _ITekstualneObjaveUI.saveTekstualnuObjavu(data.tekst);
            return Ok(data);
        }
        
       
	    //[Authorize]
        [Route("dodajSliku")]
        [HttpPost]
        public IActionResult AddImage([FromForm]PrihvatanjeSlike data)
        {
            if (data == null)
            {
                return BadRequest();
            }
            _ISlikeUI.saveImage(data);
            return Ok();
        }
	    [Authorize]
        [Route("dodajOpisSlike")]
        [HttpPost]
        public IActionResult dodajOpisSlike([FromBody]PrihvatanjeOpisaSlike data)
        {
            if (data == null)
            {
                return BadRequest();
            }

            int tip = 1; //for image, for now
            long idKorisnika = data.idKorisnika;
            PrihvatanjeObjave objava = new PrihvatanjeObjave();
            objava.idGrada = data.idGrada;
            objava.idKorisnika = data.idKorisnika;
            objava.idKategorija = data.idKategorija;
            objava.LepaStvarID = data.LepaStvarID;
            objava.tip = 1;
            _IObjaveUI.saveObjavu(objava);
            _ISlikeUI.saveOpisSlike(data);
            return Ok(data);
        }



        // api/Objave/prikaziSveObjaveii
        [Authorize]
        [Route("prikaziSveObjave")]
        [HttpPost]
        public IActionResult vratiSveObjave([FromBody]PrihvatanjeIdKorisnika aktivanKorisnik)
        {
            List<SveObjave> sveObjave = _IObjaveUI.vratiSveObjave(aktivanKorisnik);
            return Ok(sveObjave);
        }


        [Authorize]
        [Route("prikaziSveObjavePo10")]
        [HttpPost]
        public IActionResult vrati10Objava([FromBody]PrihvatanjeIdKorisnika aktivanKorisnik)
        {
            List<SveObjave> sveObjave = _IObjaveUI.daj10(aktivanKorisnik);
            return Ok(sveObjave);
        }

        [Authorize]
        [Route("prikaziSveObjaveZaGradove")]
        [HttpPost]
        public IActionResult vratiSveObjaveZaGradove([FromBody]PrihvatanjeGradova data)
        {
            if ( data == null)
            {
                return BadRequest();
            }
            List<SveObjave> sveObjave = _IObjaveUI.vratiSveObjaveZaGradove(data);
            return Ok(sveObjave);
        }
	    [Authorize]
        [Route("prikaziSveObjaveZaGrad")]
        [HttpPost]
        public IActionResult vratiSveObjaveZaGrad([FromBody]PrihvatanjeIdGrada idGrada)
        {
            if(idGrada == null)
            {
                return BadRequest();
            }
            List<SveObjave> sveObjave = _IObjaveUI.vratiSveObjaveZaGrad(idGrada);
            return Ok(sveObjave);
        }

	    [Authorize]
        [Route("dajKorisnikaByIdObjave")]
        [HttpPost]
        public IActionResult vratiKorisnikaByidObjave([FromBody]PrihvatanjeIdObjave data)
        {
            if (data == null)
            {
                return BadRequest();
            }

            Korisnik korisnik = _IObjaveUI.getIdKorisnikaByIdObjave(data); 
            
            return Ok(korisnik);
        }

        //korisnicki profil za instituciju
        [Authorize]
        [Route("dajProfilInstituciji")]
        [HttpPost]
        public IActionResult dajSveObjaveByIdKorisnikaInstitucija([FromBody]PrihvatanjeIdKorisnika data)
        {
            if (data == null)
            {
                return BadRequest();
            }

            List<SveObjave> objave = _IObjaveUI.dajProfilInstituciji(data);
            return Ok(objave);
        }


        [Authorize]
        [Route("dajSveObjaveByIdKorisnika")]
        [HttpPost]
        public IActionResult dajSveObjaveByIdKorisnika([FromBody]PrihvatanjeIdKorisnika data)
        {
            if (data == null)
            {
                return BadRequest();
            }

            List<SveObjave> objave = _IObjaveUI.dajSveObjaveByIdKorisnika(data);
            return Ok(objave);
        }
        [Authorize]
        [Route("dajSveZaObjavu")]
        [HttpPost]
        public IActionResult dajSveZaObjavu([FromBody]PrihvatanjeIdObjave data)
        {

            SveZaObjavu check = _IObjaveUI.dajSveZaObjavu(data);
            return Ok(check);
        }
	    [Authorize]
        [Route("aktivnostiKorisnika")]
        [HttpPost]
        public IActionResult dajSveZaKorisnika([FromBody]PrihvatanjeIdKorisnika data)
        {

            AktivnostiKorisnika check = _IObjaveUI.aktivnostiKorisnika(data);
            return Ok(check);
        }
        [Authorize]
        [Route("dajSliku")]
        [HttpGet]
        public string get()
        {

            var PathWithFolderName = System.IO.Path.Combine(_IWebHostEnvironment.ContentRootPath, "images\\images1.jpg");
            //var imageFileStream = File.OpenRead(PathWithFolderName);
            return Guid.NewGuid().ToString() + "_" + PathWithFolderName;
           
            //var provider = new PhysicalFileProvider(PathWithFolderName);
          //return File(PathWithFolderName, "image/jpeg");


        }
	    [Authorize]
        [Route("izmenaTekstualneObjave")]
        [HttpPost]
        public IActionResult izmenaTekstualneObjave([FromBody]TekstualneObjave objava)
        {
            if (objava == null)
            {
                return BadRequest();
            }


            _ITekstualneObjaveUI.izmenaTekstualneObjave(objava);
            return Ok();
        }
	    [Authorize]
        [Route("izmenaSlike")]
        [HttpPost]
        public IActionResult brisanjeObjave([FromBody]Slike slika)
        {
            if (slika == null)
            {
                return BadRequest();
            }

            _ISlikeUI.izmenaSlike(slika);

            return Ok();
        }
	    [Authorize]
        [Route("problemJeResen")]
        [HttpPost]
        public IActionResult resenProblem([FromBody]PrihvatanjeIdObjave data)
        {
            if (data == null)
            {
                return BadRequest();
            }
            var ind = data.idInstitucije;
            return Ok(_IObjaveUI.problemResen(data,ind));

            }
	    [Authorize]
        [Route("dajReseneObjave")]
        [HttpPost]
        public IActionResult PrikaziReseneProblem([FromBody]PrihvatanjeIdKorisnika korisnik)
        {
                return Ok(_IObjaveUI.prikaziSveReseneObjave(korisnik.idKorisnika));
        }
	    [Authorize]
        [Route("dajReseneObjavePoGradovima")]
        [HttpPost]
        public IActionResult PrikaziReseneProblemePoGradu([FromBody]PrihvatanjeGradova nizGradova)
        {
            if (nizGradova == null)
            {
                return BadRequest();
            }

            return Ok(_IObjaveUI.prikaziSveReseneObjaveZaGradove(nizGradova));
        }
	    [Authorize]
        [Route("dajNereseneObjavePoGradovima")]
        [HttpPost]
        public IActionResult PrikaziNereseneProblemePoGradu([FromBody]PrihvatanjeGradova nizGradova)
        {
            if (nizGradova == null)
            {
                return BadRequest();
            }

            return Ok(_IObjaveUI.prikaziSveNereseneObjaveZaGradove(nizGradova));
        }
	    [Authorize]
        [Route("brisanjeObjave")]
        [HttpPost]
        public IActionResult brisanjeObjave([FromBody]PrihvatanjeIdObjave data)
        {
            if (data == null)
            {
                return BadRequest();
            }
            int ind = 0;
            _IObjaveUI.deleteSveZaObjavuByIdObjave(data, ind);

            return Ok();
        }
	    [Authorize]
        [Route("prikaziNajpopularnijihObjavaPoGradovima")]
        [HttpPost]
        public IActionResult najpopularnijeObjave([FromBody] PrihvatanjeGradova nizGradova)
        {
            if (nizGradova == null)
            {
                return BadRequest();
            }
         
            var objave = _IObjaveUI.prikazNajpopularnijihObjava(nizGradova);

            return Ok(objave);
        }
        [Route("prikaziNajnepopularnijihObjavaPoGradovima")]
        [HttpPost]
        public IActionResult NajnepopularnijeObjave([FromBody] PrihvatanjeGradova nizGradova)
        {
            if (nizGradova == null)
            {
                return BadRequest();
            }

            var objave = _IObjaveUI.prikazNajnepopularnijihObjava(nizGradova);

            return Ok(objave);
        }
        [Route("prikaziObjavaPoGradovimaOdDatuma")]
        [HttpPost]
        public IActionResult prikazObjavaOdDatuma([FromBody] PrihvatanjeGradova nizGradova)
        {
            if (nizGradova == null)
            {
                return BadRequest();
            }

            var objave = _IObjaveUI.prikaziObjaveOdDatuma(nizGradova);

            return Ok(objave);
        }

        [Route("dajKategorijeProblema")]
        [HttpPost]
        public IActionResult dajKategorije([FromBody] PrihvatanjeGradova nizGradova)
        {
            if (nizGradova == null)
            {
                return BadRequest();
            }

            var objave = _IKategorijaProblemaUI.getKategorijeProblema();

            return Ok(objave);
        }

        [Authorize]
        [Route("prikazNeResenihObjavaPoKategoriji")]  //ovde
        [HttpPost]
        public IActionResult prikazNeresenihObjavaPoKategoriji([FromBody]PrihvatanjeKategorije data)
        {
            if (data == null)
            {
                return BadRequest();
            }

            return Ok(_IObjaveUI.prikazNeresenihObjavaPoKategorijamaZaKorisnika(data));
        }

        [Authorize]
        [Route("prikazResenihObjavaPoKategoriji")] //ovde
        [HttpPost]
        public IActionResult prikazResenihObjavaPoKategoriji([FromBody]PrihvatanjeKategorije data)
        {
            if (data == null)
            {
                return BadRequest();
            }

            return Ok(_IObjaveUI.prikazResenihObjavaPoKategorijiZaKorisnika(data));
        }
        [Authorize]
        [Route("prikazObjavaPoKategoriji")]
        [HttpPost]
        public IActionResult prikazObjavaPoKategoriji([FromBody]PrihvatanjeKategorije data)
        {
            if (data == null)
            {
                return BadRequest();
            }

            return Ok(_IObjaveUI.prikaziObjavePoKategorijamaZaKorisnika(data));
        }


        [Authorize]
        [Route("dajLepeStvari")]
        [HttpPost]
        public IActionResult dajLepeStvari()
        {
            
            return Ok(_IObjaveUI.getLepeStavri());
        }

    }
}
