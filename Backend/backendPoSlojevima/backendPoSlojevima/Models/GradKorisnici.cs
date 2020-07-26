using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.Models
{
    public class GradKorisnici
    {
         public long id { get; set; }
        public long GradID { get; set; }
        public virtual Grad grad { get; set; }
        public long KorisnikID { get; set; }
        public virtual Korisnik korisnik { get; set; }

    }
}
