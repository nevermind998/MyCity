using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.UI.Interfaces
{
    public interface IGradUI
    {
        List<Grad> getAllGradove();
        Grad getGradByIdGrada(long idGrada);
        List<Grad> getGradoveByNizIdGradova(List<long> nizGradova);
    }
}
