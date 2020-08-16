using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.Models
{
    public class PrihvatanjeTekstualneObjave
    {

        public String tekst { get; set; }
        public long idKorisnika { get; set; }
        public long idGrada { get; set; }
        public int tip { get; set; }
    }
}
