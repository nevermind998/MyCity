using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.BL.Interfaces
{
    public interface IGradBL
    {
        List<Grad> getAllGradove();
        Grad getGradByIdGrada(long idGrada);
        List<Grad> getGradoveByNizIdGradova(List<long> nizGradova);
    }
}
