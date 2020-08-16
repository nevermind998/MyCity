using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using backendPoSlojevima.Data;
using backendPoSlojevima.Models;
using backendPoSlojevima.UI.Interfaces;
using System.IO;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Authorization;



namespace backendPoSlojevima.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ObjaveKategorijeController : Controller
    {
        private readonly IObjaveKategorijeUI _IObjaveKategorijeUI;
        private readonly IObjaveUI _IObjaveUI;

        public ObjaveKategorijeController(IObjaveKategorijeUI IObjaveKategorijeUI, IObjaveUI IObjaveUI)
        {
            _IObjaveKategorijeUI = IObjaveKategorijeUI;
            _IObjaveUI = IObjaveUI;
        }


        [Route("dajObjaveZaKategoriju")] //po vremenu prikaza su sortirane
        [HttpPost]
        public IActionResult dajObjaveZaKategoriju([FromBody]PrihvatanjeObjave data)
        {
            if (data == null)
            {
                return BadRequest();
            }

            return Ok(_IObjaveUI.getObjaveByIdKategorije(data.idKategorija));
        }
    }
}
