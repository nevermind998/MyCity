using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.Models
{
    public class SveZaObjavu
    {

        public long  idObjave { get; set; }
        public int aktivanKorisnikLajkova { get; set; }
        public int aktivanKorisnikDislajkova{ get; set; }
        public int aktivanKorisnikReportovao { get; set; }
        public long brojLajkova { get; set; }
        public long brojDislajkova { get; set; }
        public long brojReporta { get; set; }
        public long brojKomentara { get; set; }
        
        public List<SveZaKomentare> komentari { get; set; }
    }
}
