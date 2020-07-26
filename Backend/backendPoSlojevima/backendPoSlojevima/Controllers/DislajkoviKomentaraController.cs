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
    public class DislajkoviKomentaraController : Controller
    {
        private readonly IDislajkoviKomentaraUI _IDislajkoviKomentaraUI;
        public DislajkoviKomentaraController (IDislajkoviKomentaraUI IDislajkoviKomentaraUI)
        {
            _IDislajkoviKomentaraUI = IDislajkoviKomentaraUI;
        }

        // GET: api/DislajkoviKomentara
        [HttpPost]
        public async Task<ActionResult<List<DislajkoviKomentari>>> GetDislajkove()
        {
            return _IDislajkoviKomentaraUI.getAllDislajkovi();
        }
	    [Authorize]
        [Route("dodajDislajk")]
        [HttpPost]
        public IActionResult AddDislajk([FromBody]Prihvatanje2 data)
        {
            if (data == null)
            {
                return BadRequest();
            }
            DislajkoviKomentari dislajk = new DislajkoviKomentari();
            dislajk.KomentarID = data.idKomentara;
            dislajk.KorisnikID = data.idKorisnika;
            _IDislajkoviKomentaraUI.saveDislajk(dislajk);
            return Ok(data);
        }
        [Route("dajDislajkove")]
        [HttpPost]
        public List<Korisnik> vidiLajkove([FromBody]PrihvatanjeIdKomentara data)
        {
            return _IDislajkoviKomentaraUI.getKorisnikeKojiDislajkujuByIdKomentara(data.idKomentara);
        }

    }
}
