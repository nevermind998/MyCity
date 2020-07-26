using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.Models
{
    public class PrihvatanjeGradova
    { 
        public List<long> idGradova { get; set; }
        public DateTime vreme { get; set; }
        public long idKorisnika { get; set; }

    }
}
