using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.Models
{
    public class PrihvatanjeSlikeKomentara
    {
        public IFormFile slika { get; set; }
        public int resenProblem { get; set; } //1 -> resen problem, 0->obican komentar
    }
}
