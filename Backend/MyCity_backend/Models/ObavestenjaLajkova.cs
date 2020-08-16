using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.Models
{
    public class ObavestenjaLajkova
    {
        public long id { get; set; }
        public long LajkoviID { get; set; }
        public  virtual Lajkovi lajkovi { get; set; }
        public int procitano { get; set; }

    }
}
