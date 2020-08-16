using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.Models
{
    public class SveZaReseneProbleme
    {
        public long id { get; set; }
        public Korisnik korisnik { get; set; }
        public long idObjave { get; set; }
        public String tekst { get; set; }
        public String urlSlike { get; set; }
    }
}
