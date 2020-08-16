using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using backendPoSlojevima.Data;
using backendPoSlojevima.Models;
using backendPoSlojevima.UI.Interfaces;
using Microsoft.AspNetCore.Authorization;

// For more information on enabling MVC for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace backendPoSlojevima.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class GradKorisniciController : Controller
    {
        private readonly IGradKorisniciUI _IGradKorisniciUI;

       public GradKorisniciController (IGradKorisniciUI IGradKorisniciUI)
        {
            _IGradKorisniciUI = IGradKorisniciUI;
        }

        // GET: api/GradKorisnici
        [HttpGet]
        public async Task<ActionResult<IEnumerable<GradKorisnici>>> GetGradKorisnici()
        {
            return _IGradKorisniciUI.getAllGradKorisnici();
        }
	    [Authorize]
        [Route("dajGradoveZaKorisnika")]
        [HttpPost]
        public IActionResult getGrad([FromBody] PrihvatanjeIdKorisnika korisnika)
        {
            return Ok(_IGradKorisniciUI.getAllGradoveByIdKorisnika(korisnika.idKorisnika));
        }


    }
}
