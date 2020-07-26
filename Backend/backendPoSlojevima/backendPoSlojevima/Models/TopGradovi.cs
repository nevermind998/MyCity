using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.Models
{
    public class TopGradovi
    {
        public long idGrada { get; set; }
        public String nazivGrada { get; set; }
        public long brojPoena { get; set; }
        public long ukupno { get; set; }
    }
}
