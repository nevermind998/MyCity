using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.Models
{
    public class PrihvatanjeKoda
    {
        public long id { get; set; }
        public String username { get; set; }
        public String password { get; set; }
        public long kod { get; set; }
        public String potvrda { get; set; }
    }
}
