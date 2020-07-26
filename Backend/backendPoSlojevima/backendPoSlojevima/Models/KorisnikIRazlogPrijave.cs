using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.Models
{
    public class KorisnikIRazlogPrijave
    {
        public long idObjave { get; set; }
        public String razlog { get; set; }
        public long id { get; set; }
        public String email { get; set; }
        public String username { get; set; }
        public String password { get; set; }
        public String ime { get; set; }
        public String prezime { get; set; }
        public String biografija { get; set; }
        public String Token { get; set; }
        public String uloga { get; set; }
        public String urlSlike { get; set; }
        public long poeni { get; set; }
        public int ocenaAplikacije { get; set; }
    }
}
