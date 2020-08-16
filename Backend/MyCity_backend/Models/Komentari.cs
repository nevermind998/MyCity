using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.Models
{
    public class Komentari
    {
        public long id { get; set; }
        public long KorisnikID { get; set; }
        public virtual Korisnik korisnik { get; set; }
        public long ObjaveID { get; set; }
        public virtual Objave objave { get; set; }
        public String tekst { get; set; }
        public String urlSlike { get; set; }
        public int oznacenKaoResen { get; set; }
        public int resenProblem { get; set; }

    }
}
