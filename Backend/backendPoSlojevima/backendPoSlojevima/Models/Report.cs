using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.Models
{
    public class Report
    {
        public long id { get; set; }
        public long KorisnikID { get; set; }
        public virtual Korisnik korisnik { get; set; }
        public long ObjaveID { get; set; }
        public virtual Objave objave { get; set; }
        public long RazlogID { get; set; }
        public virtual RazlogPrijave razlog { get; set; }

    }
}
