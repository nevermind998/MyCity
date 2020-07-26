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
    public class DislajkoviController : Controller
    {
        private readonly IDislajkoviUI _IDislajkoviUI;

        public DislajkoviController(IDislajkoviUI IDislajkoviUI)
        {
            _IDislajkoviUI = IDislajkoviUI;
        }


        // GET: api/Dislajkovi
        [HttpPost]
        public async Task<ActionResult<List<Dislajkovi>>> GetDislajkove()
        {
            return _IDislajkoviUI.getAllDislajkovi();
        }
	    [Authorize]
        [Route("dodajDislajk")]
        [HttpPost]
        public IActionResult AddDislajk([FromBody]Prihvatanje data)
        {
            if (data == null)
            {
                return BadRequest();
            }
            Dislajkovi dislajk = new Dislajkovi();
            dislajk.KorisnikID = data.idKorisnika;
            dislajk.ObjaveID = data.idObjave;
            _IDislajkoviUI.saveDislajk(dislajk);
            return Ok(data);
        }

        [Route("dajDislajkove")]
        [HttpPost]
        public IActionResult vidiLajkove([FromBody]PrihvatanjeIdObjave data)
        {
            if (data == null)
            {
                return BadRequest();
            }
            return Ok(_IDislajkoviUI.getKorisnikeKojiDislajkujuByIdObjave(data));
        }

    }
}
