using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using backendPoSlojevima.Models;
using backendPoSlojevima.UI.Interfaces;


namespace backendPoSlojevima.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class GradoviController : Controller
    {
        private readonly IGradUI _IGradUI;

        public GradoviController (IGradUI IGradUI)
        {
            _IGradUI = IGradUI;
        }

        // GET: api/Grad
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Grad>>> GetGrad()
        {
            return _IGradUI.getAllGradove();
        }

    }
}
