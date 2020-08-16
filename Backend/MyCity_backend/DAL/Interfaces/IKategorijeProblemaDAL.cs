using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.DAL.Interfaces
{
    public interface IKategorijeProblemaDAL
    {
        public List<KategorijeProblema> getKategorijeProblema();
        
    }
}
