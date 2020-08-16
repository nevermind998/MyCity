using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.DAL.Interfaces
{
    public interface IGradDAL
    {
        List<Grad> getAllGradove();
        int proveraIdGrada(long idGrada);
    }
}
