using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.Models
{
    public class Institucije
    {
        public long id { get; set; }
        public String broj_telefona { get; set; }
        public String username { get; set; }
        public String password { get; set; }
        public String naziv { get; set; }
        public String biografija { get; set; }
        public String Token { get; set; }
        public String urlSlike { get; set; }
    }
}
