using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.Models
{
    public class StatistikaGradova
    {

        public long idGrada { get; set; }
        public String nazivGrada { get; set; }
        public long  brojGradjana { get; set; }
        public long  brojInstitucija { get; set; }
        public long  ukupno { get; set; }
    }
}
