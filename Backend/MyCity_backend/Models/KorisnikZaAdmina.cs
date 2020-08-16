using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.Models
{
    public class KorisnikZaAdmina
    {
        public long id { get; set; }
        public String broj_telefona { get; set; }
        public String username { get; set; }
        public String password { get; set; }
        public String ime { get; set; }
        public String prezime { get; set; }
        public String biografija { get; set; }
        public String Token { get; set; }
        public String uloga { get; set; }
        public String urlSlike { get; set; }
        public long poeni { get; set; }
        public long brojResenih { get; set; }
        public long brojNeresenih { get; set; }
        public long ocenaAplikacije { get; set; }
        public long brojUkupnih { get; set; }
        public long brojPrijavljenihKomentara { get; set; }
        public long brojPrijavljenihObjava { get; set; }
        public List<Grad> gradovi { get; set; }
    }
}
