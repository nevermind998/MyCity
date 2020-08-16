using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using backendPoSlojevima.Models;
using backendPoSlojevima.UI.Interfaces;
using Microsoft.AspNetCore.Authorization;

namespace backendPoSlojevima.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ObavestenjaController : Controller
    {
        private readonly IObavestenjaUI _IObavestenjaUI;
        
        public ObavestenjaController(IObavestenjaUI IObavestenjaUI)
        {
            _IObavestenjaUI = IObavestenjaUI;
        }


        [Authorize]
        [Route("dajObavestenja")]
        [HttpPost]
        public async Task<ActionResult<IEnumerable<Obavestenja>>> getObavestanjaZaKorisnika([FromBody] PrihvatanjeIdKorisnika korisnik)
        {
            if (korisnik == null)
            {
                return BadRequest();
            }
            return Ok(_IObavestenjaUI.getAllObavestenjaByIdVlasnika(korisnik.idKorisnika));
        }

        [Authorize]
        [Route("dajLajkove")]
        [HttpPost]
        public async Task<ActionResult<IEnumerable<ObavestenjaLajkova>>> getLajkove([FromBody] PrihvatanjeIdKorisnika korisnik)
        {
            if (korisnik == null)
            {
                return BadRequest();
            }
            return Ok(_IObavestenjaUI.getLajkoveByIdVlasika(korisnik.idKorisnika));
        }


        [Authorize]
        [Route("procitano")]
        [HttpPost]
        public IActionResult procitano([FromBody] PrihvatanjeIdKorisnika korisnik)
        {
            if (korisnik == null)
            {
                return BadRequest();
            }
            _IObavestenjaUI.procitano(korisnik.idKorisnika);
            return Ok();
        }


        [Authorize]
        [Route("brojNeprocitanih")]
        [HttpPost]
        public IActionResult neprocitane([FromBody] PrihvatanjeIdKorisnika korisnik)
        {
            if (korisnik == null)
            {
                return BadRequest();
            }
            return Ok(_IObavestenjaUI.neprocitanaObavestenja(korisnik.idKorisnika));
        }

    }
}
