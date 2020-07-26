using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.Models
{
    public class ObavestenjaKomentari
    {
        public long id { get; set; }
        public int procitano { get; set; }
        public long KomentarID { get; set; }
        public virtual Komentari komentar { get; set; }



    }
}
