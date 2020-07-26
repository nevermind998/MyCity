using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.Models
{
    public class InstitucijeKategorije
    {
        public long id { get; set; }
        public long InstitucijaID { get; set; }
        public virtual Korisnik institucija { get; set; }
        public long KategorijaID { get; set; }
        public virtual KategorijeProblema kategorija { get; set; }
    }
}
