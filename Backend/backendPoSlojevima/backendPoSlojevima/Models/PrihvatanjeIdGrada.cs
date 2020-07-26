using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.Models
{
    public class PrihvatanjeIdGrada
    {
        public long idGrada { get; set; }
        public long idKorisnika { get; set; }
        public long kategorija {get; set;}
    }
}
