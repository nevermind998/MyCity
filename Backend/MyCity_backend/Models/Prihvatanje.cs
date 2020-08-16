using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.UI.Interfaces
{
    public class Prihvatanje
    {
        public long id { get; set; }
        public long idKorisnika { get; set; }
        public long idObjave { get; set; }
        public long RazlogID { get; set; }
    }
}
