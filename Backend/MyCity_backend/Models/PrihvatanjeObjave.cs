using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.Models
{
    public class PrihvatanjeObjave
    {
        public long id { get; set; }
        public String tekst { get; set; }
        public long idKorisnika { get; set; }
        public long idGrada { get; set; }
        public int tip { get; set; }
       
        public List<long> idKategorija { get; set; }
        public long LepaStvarID { get; set; }
    }
}
