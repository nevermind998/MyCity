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
    public class ReportKomentaraController : Controller
    {
        private readonly IReportKomentaraUI _IReportKomentaraUI;

        public ReportKomentaraController(IReportKomentaraUI IReportKomentaraUI)
        {
            _IReportKomentaraUI = IReportKomentaraUI;
        }
      /*  // GET: api/ReportKomentara
        [HttpGet]
        public async Task<ActionResult<IEnumerable<ReportKomentari>>> GetReport()
        {
            return _IReportKomentaraUI.getAllReport();
        }*/
	    [Authorize]
        [Route("dodajReport")]
        [HttpPost]
        public IActionResult AddReport([FromBody]Prihvatanje2 data)
        {
            if (data == null)
            {
                return BadRequest();
            }
            ReportKomentari report = new ReportKomentari();
            report.KomentarID = data.idKomentara;
            report.KorisnikID = data.idKorisnika;
            _IReportKomentaraUI.saveReport(report);
            return Ok();
        }

	[Authorize]
        [Route("dajReportove")]
        [HttpPost]
        public List<Korisnik> dajReportove([FromBody]PrihvatanjeIdKomentara data)
        {
            return _IReportKomentaraUI.getKorisnikeKojiReportujuByIdKomentara(data.idKomentara);
        }

    }
}
