using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.Models
{
    public class DislajkoviKomentari
    {
        public int id { get; set; }
        public long KomentarID { get; set; }
        public virtual Komentari komentar { get; set; }

        public long KorisnikID { get; set; }
        public virtual Korisnik korisnik { get; set; }
    }
}
