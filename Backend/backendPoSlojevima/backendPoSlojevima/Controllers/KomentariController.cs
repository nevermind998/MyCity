using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using backendPoSlojevima.Data;
using backendPoSlojevima.Models;
using backendPoSlojevima.UI.Interfaces;
using Microsoft.AspNetCore.Authorization;

namespace backendPoSlojevima.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class KomentariController : Controller
    {
        private readonly IKomentariUI _IKomentariUI;

        public KomentariController(IKomentariUI IKomentariUI)
        {
            _IKomentariUI = IKomentariUI;
        }

        // GET: api/Komentari
        [HttpPost]
        public async Task<ActionResult<List<Komentari>>> GetKomentare()
        {
            return _IKomentariUI.getAllKomentari();
        }
	    //[Authorize]
        [Route("dodajSliku")]
        [HttpPost]
        public IActionResult AddKomentar([FromForm]PrihvatanjeSlikeKomentara data)
        {
            if (data == null)
            {
                return BadRequest();
            }

            _IKomentariUI.saveImage(data);
      
            return Ok();
        }
  	    [Authorize]
        [Route("dodajKomentar")]
        [HttpPost]
        public IActionResult AddKomentar([FromBody]PrihvatanjeKomentara data)
        {
            if (data == null)
            {
                return BadRequest();
            }
            // public int resenProblem { get; set; } // 1 -> resen problem, 0 ->obican komentar
           
            _IKomentariUI.saveKomentar(data);
            return Ok();
        }
	   //[Authorize]
        [Route("dodajResenjeOdInstitucije")]
        [HttpPost]
        public IActionResult dodajSliku([FromBody]PrihvatanjeResenihProbelma data)
        {
            if (data == null)
            {
                return BadRequest("blah");
            }
            _IKomentariUI.saveResenjeInstitucije(data);
            return Ok();
        }


	[Authorize]
        [Route("dajKomentare")]
        [HttpPost]
        public IActionResult vidiKomentare([FromBody]PrihvatanjeKomentara data)
        {
            if (data == null)
            {
                return BadRequest();
            }
            return Ok(_IKomentariUI.sveZaKomentare(data));
        }
	[Authorize]
        [Route("dajReseneProbleme")]
        [HttpPost]
        public IActionResult reseniProblemi([FromBody]PrihvatanjeKomentara data)
        {
            if (data == null)
            {
                return BadRequest();
            }
            return Ok(_IKomentariUI.getAllReseneProbleme());
        }
	    [Authorize]
        [Route("dajOznaceneKaoReseniProblemiZaObjavu")]
        [HttpPost]
        public IActionResult reseniProblemiPoObjavi([FromBody]PrihvatanjeIdObjave data)
        {
            if (data == null)
            {
                return BadRequest();
            }
            return Ok(_IKomentariUI.getOznacenaReseneProblemeByIdObjave(data));
        }
	    [Authorize]
        [Route("dajReseneProblemeZaObjavu")]
        [HttpPost]
        public IActionResult OznaceniKaoReseniProblemiPoObjavi([FromBody]PrihvatanjeIdObjave data)
        {
            if (data == null)
            {
                return BadRequest();
            }
            return Ok(_IKomentariUI.getReseneProblemeByIdObjave(data));
        }
	    [Authorize]

        [Route("problemJeResen")]
        [HttpPost]
        public IActionResult resenProblem([FromBody]PrihvatanjeIdKomentara data)
        {
            if (data == null)
            {
                return BadRequest();
            }
            return Ok(_IKomentariUI.problemResen(data));
        }
	    [Authorize]
        [Route("dodajViseResenja")]
        [HttpPost]
        public IActionResult dodajViseResenihKomentara([FromBody]PrihvatanjeNizaKomentara idKomentara)
        {
            if (idKomentara == null)
            {
                return BadRequest();
            }
    
            _IKomentariUI.problemResenSaViseKomentara(idKomentara);
            return Ok();
        }
	    [Authorize]
        [Route("brisanjeKomentara")]
        [HttpPost]
        public IActionResult brisanjeKorisnika([FromBody]PrihvatanjeIdKomentara data)
        {
            if (data == null)
            {
                return BadRequest();
            }
            int ind = 0; //korisnik
            _IKomentariUI.deleteKomentarByIdKomentara(data, ind);

            return Ok();
        }
        [Authorize]
        [Route("izmenaKomentara")]
        [HttpPost]
        public IActionResult izmenaKomentara([FromBody]Komentari data)
        {
            if (data == null)
            {
                return BadRequest();
            }
            int ind = 0; //korisnik
            _IKomentariUI.izmenaKomentara(data);

            return Ok();
        }

    }
}
