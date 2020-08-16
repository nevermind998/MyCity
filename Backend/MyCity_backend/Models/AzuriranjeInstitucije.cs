using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.Models
{
    public class AzuriranjeInstitucije
    {
        public Korisnik korisnik { get; set; }
        public List<long> idGradova { get; set; }

        public List<long> kategorije { get; set; }
        public string newPassword { get; set; }
    }
}
