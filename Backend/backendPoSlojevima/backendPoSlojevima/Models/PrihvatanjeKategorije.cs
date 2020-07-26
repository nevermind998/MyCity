using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.Models
{
    public class PrihvatanjeKategorije
    {
        public Korisnik institucija { get; set; }
        public List<long> idKategorije { get; set; }
        public long idKorisnika { get; set; }
        public long kategorija { get; set; }
    }
}
