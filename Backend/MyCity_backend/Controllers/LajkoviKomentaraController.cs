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
    public class LajkoviKomentaraController : Controller
    {
        private readonly ILajkoviKomentaraUI _ILajkoviKomentaraUI;

        public LajkoviKomentaraController(ILajkoviKomentaraUI ILajkoviKomentaraUI)
        {
            _ILajkoviKomentaraUI = ILajkoviKomentaraUI;
        }
     /*   // GET: api/LajkoviKomentara
        [HttpGet]
        public async Task<ActionResult<List<LajkoviKomentara>>> GetLajkove()
        {
            return _ILajkoviKomentaraUI.getAllLajkovi();
        }
        */
	    [Authorize]
        [Route("dodajLajk")]
        [HttpPost]
        public IActionResult AddLajk([FromBody]Prihvatanje2 data)
        {
            if (data == null)
            {
                return BadRequest();
            }
            LajkoviKomentara lajk = new LajkoviKomentara();
            lajk.KomentarID = data.idKomentara;
            lajk.KorisnikID = data.idKorisnika;
 
            _ILajkoviKomentaraUI.saveLajk(lajk);
            return Ok();
        }
	[Authorize]
        [Route("dajLajkove")]
        [HttpPost]
        public List<Korisnik> vidiLajkove([FromBody]PrihvatanjeIdKomentara data)
        {
            return _ILajkoviKomentaraUI.getKorisnikeKojiLajkujuByIdKomentara(data.idKomentara);
        }
    }
}
