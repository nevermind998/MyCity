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
    public class LajkoviController : Controller
    {
        private readonly ILajkoviUI _ILajkoviUI;

        public LajkoviController(ILajkoviUI ILajkoviUI)
        {
            _ILajkoviUI = ILajkoviUI;
        }

     /*   // GET: api/Lajkovi
        [HttpGet]
        public async Task<ActionResult<List<Lajkovi>>> GetLajkove()
        {
            return _ILajkoviUI.getAllLajkovi();
        }

        */
	    [Authorize]
        [Route("dodajLajk")]
        [HttpPost]
        public IActionResult AddLajk([FromBody]Prihvatanje data)
        {
            if (data == null)
            {
                return BadRequest();
            }
            Lajkovi lajk = new Lajkovi(); 
            lajk.KorisnikID = data.idKorisnika;
            lajk.ObjaveID = data.idObjave;

            _ILajkoviUI.saveLajk(lajk);
            return Ok(data);
        }
        [Authorize]
        [Route("dajLajkove")]
        [HttpPost]
        public  IActionResult vidiLajkove([FromBody]PrihvatanjeIdObjave data)
        {
            if(data == null)
            {
                return BadRequest();
            }
            return Ok(_ILajkoviUI.getKorisnikeKojiLajkujuByIdObjave(data));
        }
       



    }

}
