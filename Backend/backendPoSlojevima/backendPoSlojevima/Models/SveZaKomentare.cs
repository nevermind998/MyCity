using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.Models
{
    public class SveZaKomentare
    {
        public long id { get; set; }
        public KorisnikSaGradovima korisnik { get; set; }
        public long idObjave { get; set; }
        public String tekst { get; set; }
        public String urlSlike { get; set; }
        public long brojLajkova { get; set; }
        public long brojDislajkova { get; set; }
        public long brojReporta { get; set; }
        public int aktivanKorisnikLajkovao { get; set; }
        public int aktivanKorisnikDislajkovao { get; set; }
        public int aktivanKorisnikReportovao { get; set; }
        public int oznacenKaoResen { get; set; }
        public int resenProblem { get; set; }
    }
}
