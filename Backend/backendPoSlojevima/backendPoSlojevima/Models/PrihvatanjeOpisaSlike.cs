using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.Models
{
    public class PrihvatanjeOpisaSlike
    {
        public long idKorisnika { get; set; }
        public long idObjave { get; set; }
        public float x { get; set; }
        public float y { get; set; }
        public String opis_slike { get; set; }
        public String urlSlike { get; set; }
        public long idGrada { get; set; }
        public List<long> idKategorija { get; set; }
        public long LepaStvarID { get; set; }
    }
}
