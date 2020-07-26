using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.Models
{
    public class PrihvatanjeIdKorisnika
    {
        public long idKorisnika { get; set; }
        public long idAdmina { get; set; }
        public long aktivanKorisnik { get; set; }
        public long idGrada { get; set; }
        public long odBroja { get; set; }
        public long doBroja { get; set; }
        public int index { get; set; }
        public int ocena { get; set; }

    }
}
