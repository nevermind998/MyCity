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
    public class ReportController : Controller
    {

        private readonly IReportUI _IReportUI;
        public ReportController(IReportUI IReportUI)
        {
            _IReportUI = IReportUI;
        }

        /*// GET: api/Report
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Report>>> GetReport()
        {
            return _IReportUI.getAllReport();
        }*/
	    [Authorize]
        [Route("dodajReport")]
        [HttpPost]
        public IActionResult AddReport([FromBody]Prihvatanje data)
        {
            if (data == null)
            {
                return BadRequest();
            }

            Report report = new Report();
            report.KorisnikID = data.idKorisnika;
            report.ObjaveID = data.idObjave;
            report.RazlogID = data.RazlogID;
           int ind = _IReportUI.saveReport(report);
            if (ind == 1)
            {
                return Ok(data);
            }
            else
            {
                return NoContent();
            }
        }
	    [Authorize]
        [Route("dajReportove")]
        [HttpPost]
        public IActionResult  dajReportove([FromBody]PrihvatanjeIdObjave data)
        {
            return Ok(_IReportUI.getKorisnikeKojiReportujuByIdObjave(data));
        }

        [Authorize(Roles = "admin,superuser")]
        [Route("dajReportoveZaAdmina")]
        [HttpPost]
        public IActionResult dajReportoveZaAdmina([FromBody]PrihvatanjeIdObjave data)
        {
            return Ok(_IReportUI.getKorisnikeIRazlogPrijave(data.idObjave));
        }

        [Route("dajRazlogePrijave")]
        [HttpPost]
        public IActionResult dajRazlogprijave()
        {
            return Ok(_IReportUI.getRazlogePrijave());
        }



    }
}
