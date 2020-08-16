using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.Models
{
    public class AktivnostiKorisnika
    {

        public List<Lajkovi> lajkovi { get; set; }
        public  List<Dislajkovi> dislajkovi { get; set; }
        public List<Report> reportovi { get; set; }
        public List<Komentari> komentari { get; set; }
    }
}
