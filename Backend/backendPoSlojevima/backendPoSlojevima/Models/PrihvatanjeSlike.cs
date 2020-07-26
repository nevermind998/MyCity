using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.Models
{
    public class PrihvatanjeSlike
    {
        public IFormFile slika { get; set; }
        public String urlSlike { get; set; }
        
    }
}
