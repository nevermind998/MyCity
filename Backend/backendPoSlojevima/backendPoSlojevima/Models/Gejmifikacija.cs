using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.Models
{
    public class Gejmifikacija
    {
        public List<Boje> boje { get; set; }
        public Boje bojaKorisnika { get; set; }
        public long poeniDoSledeceBoje { get; set; }
    }
}
