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
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class TekstualneObjaveController : Controller
    {

        private readonly ITekstualneObjaveUI _ITekstualneObjaveUI;

        public TekstualneObjaveController(ITekstualneObjaveUI ITekstualneObjaveUI)
        {
            _ITekstualneObjaveUI = ITekstualneObjaveUI;
        }

      /*  // GET: api/TekstualneObjave
        [HttpGet]
        public async Task<ActionResult<IEnumerable<TekstualneObjave>>> GetTekstualnuObjave()
        {
            return   _ITekstualneObjaveUI.getAllTekstualneObjave();
        }*/
    }

 
}
