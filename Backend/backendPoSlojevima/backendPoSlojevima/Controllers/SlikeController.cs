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
    public class SlikeController : Controller
    {
        private readonly ISlikeUI _ISlikeUI;
        public SlikeController(ISlikeUI ISlikeUI)
        {
            _ISlikeUI = ISlikeUI;
            
        }
        /*
       // GET: api/Slike
        [HttpGet]
        public ActionResult<IEnumerable<Slike>> GetSlike()
        {
            return _ISlikeUI.getImages();
        }
        */

       
    }
}