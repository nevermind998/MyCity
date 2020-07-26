using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.Models
{
    public class StatistikaObjava
    {
        public long brojResenihObjava { get; set; }
        public long brojNeresenihObjava { get; set; }
        public long prosecnaBrojLajkovaR { get; set; }
        public long prosecnaBrojDislajkovaR { get; set; }
        public long prosecnaBrojPrijavaR { get; set; }
        public long prosecnaBrojKomentaraR { get; set; }
        public long prosecnaBrojLajkovaN { get; set; }
        public long prosecnaBrojDislajkovaN { get; set; }
        public long prosecnaBrojPrijavaN { get; set; }
        public long prosecnaBrojKomentaraN { get; set; }

    }
}
