using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.Models
{
    public class StatistikaKategorije
    {
        public long brojResenihProblema { get; set; }
        public long brojNeresenihProblema { get; set; }
        public long ukupnanBroj { get; set; }
        public String imeKategorije { get; set; }
        public long idKategorije { get; set; }
    }
}
