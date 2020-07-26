using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.Models
{
    public class PrihvatanjeResenihProbelma
    {
        public long idInstitucije { get; set; }
        public long idObjave { get; set; }
        public String tekst { get; set; }
        public String base64 { get; set; }
    }
}
