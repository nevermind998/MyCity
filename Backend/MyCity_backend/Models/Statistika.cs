using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.Models
{
    public class Statistika
    {
        public long idGrada { get; set; }
        public long brojKorisnika { get; set; }
        public long brojInstitucija { get; set; }
        public long brojGradjana { get; set; }
        public long brojResenihProblema { get; set; }
        public long brojNeresenihProblema { get; set; }
        public long ukupnanBroj { get; set; }
        public long brojPrijavljenihObjava { get; set; }
       
    }
}
