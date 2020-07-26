using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.Models
{
    public class PretragaKorisnika
    {
        
        public String filter { get; set; }
        public long idGrada { get; set; }
        public String objava { get; set; }
        public String komentar { get; set; }
        public long odBrojaObjava { get; set; }
        public long doBrojaObjava { get; set; }
        public long odBrojaKomentara { get; set; }
        public long doBrojaKomentara { get; set; }
    }
}
