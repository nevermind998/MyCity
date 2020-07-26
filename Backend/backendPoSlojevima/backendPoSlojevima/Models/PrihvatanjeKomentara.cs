using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.Models
{
    public class PrihvatanjeKomentara
    {
  
        public long idKorisnika { get; set; }
        public long idObjave { get; set; }
        public String tekst { get; set; }
        public int poslataSlika { get; set; }
        public int resenProblem { get; set; } // 1 -> resen problem, 0 ->obican komentar
        public int oznacenKaoResen { get; set; }

    }
}
